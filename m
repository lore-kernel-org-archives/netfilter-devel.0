From: Alexander Nasonov <alnsn-mycop@yandex.ru>
Subject: Re: ASN.1 decoder for h323-conntrack-nat
Date: Fri, 17 Oct 2003 11:37:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F8FB86D.8070401@yandex.ru>
References: <Pine.LNX.4.33.0310170956080.7119-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0310170956080.7119-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:

>Such optimizations would be highly preferred. The code ran not only
>faster but I think were smaller as well.
>  
>
I've just finished an analysis of CloseLogicalChannel. It's amazing how 
greatly it can be reduced after optimization.

LogicalChannelNumber    ::=INTEGER (1..65535)

CloseLogicalChannel    ::=SEQUENCE
{
    forwardLogicalChannelNumber    LogicalChannelNumber,
    source        CHOICE
    {
        user    NULL,
        lcse    NULL
    },
    ...,
    reason        CHOICE
    {
        unknown    NULL,
        reopen    NULL,
        reservationFailure    NULL,
        ...
    }
}

1. CloseLogicalChannel is a sequence without optional/default fields and 
with extention => first bit signal the presense of extention(s)
2. LogicalChannelNumber is aligned two bytes => data after this field is 
aligned
3. "source" choice has two choices and no extention => one bit: 0 for 
user, 1 for lcse. This is bit 7 (most significant) because of previous item.
4. user and lcse are NULL => no bits

int CloseLogicalChannel(asn1_message_data* asn)
{
    // 3 = one byte for alignement + two bytes for LogicalChannelNumber 
+ one byte for "source" field
    if(asn->bytes_left <= 3)
        return ERROR_UNEXPECTED_END;
    bool hasExtentions = asn->current_byte & (1 << asn->bit_position);
    asn->bytes_left -= 3;
    asn->current_byte += 3;
    asn->bit_position = 6; // bit 7 is used by "source" field
    return hasExtentions ? skip_sequence_extentions(asn) : SUCCESS;
}

Compare it with a current code to see the difference (unexpected end of 
data is signaled by throwing C++ exception from functions):

  void f_MSC__CloseLogicalChannel_source__user()
  {
      // NULL
  }

  void f_MSC__CloseLogicalChannel_source__lcse()
  {
      // NULL
  }

  void f_MSC__CloseLogicalChannel_source()
  {
      // CHOICE { < 2 field(s) > }
      size_t len;
      unsigned char* saved_byte;
      unsigned int choice = GetBits1();
      switch(choice)
      {
        case 0:
          f_MSC__CloseLogicalChannel_source__user();
          break;
        case 1:
          f_MSC__CloseLogicalChannel_source__lcse();
          break;
      }
  }

  void f_MSC__LogicalChannelNumber()
  {
      // INTEGER(1..65535)
      Align();
      unsigned int byte1 = GetByte();
      unsigned int byte2 = GetByte();
      unsigned long value = 1 + (256 * byte1 + byte2);
  }

  void f_MSC__CloseLogicalChannel__forwardLogicalChannelNumber()
  {
      f_MSC__LogicalChannelNumber();
  }

  void f_MSC__CloseLogicalChannel__source()
  {
      f_MSC__CloseLogicalChannel_source();
  }

  void f_MSC__CloseLogicalChannel()
  {
      // SEQUENCE { < 2 field(s) > ,..., < 1 field(s) > }
      unsigned int bits = GetBits1();
      f_MSC__CloseLogicalChannel__forwardLogicalChannelNumber();
      f_MSC__CloseLogicalChannel__source();

      if(bits) // extentions?
      {
          bool ext[1];
          size_t extCount = GetNormallySmallLength();
          ReadBitmap(ext, extCount > 1 ? 1 : extCount);
          size_t extSkip = extCount > 1 ? CountSetBits(extCount - 1) : 0;

          if(extCount > 0 && ext[0])
          {
              size_t len = GetSemiConstrainedLength();
              unsigned char* saved_byte = m_byte;
              f_MSC__CloseLogicalChannel__reason();
              m_byte = saved_byte;
              SkipBytes(len);
          }

          for(; extSkip; --extSkip)
              SkipDataWithSemiConstrainedLength();
      }
  }

--
Alexaner Nasonov
