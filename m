From: Alexander Nasonov <alnsn-mycop@yandex.ru>
Subject: Re: ASN.1 decoder for h323-conntrack-nat
Date: Thu, 16 Oct 2003 16:11:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F8EA725.9090000@yandex.ru>
References: <Pine.LNX.4.33.0310161528160.4832-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0310161528160.4832-100000@blackhole.kfki.hu>
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

> That would be great! We cannot use code written in C++.

I'm using C++ simply because C++ has inline functions and if you put all 
these functions (with bodies) into the class scopr you don't need to 
worry about the order in which they should be placed. I can rewrite the 
generator to generate C code (the generator itself will be written in 
C++ anyway).

>[Actually, I have just discovered that the source code of the most recent
>ethereal contains ASN.1 PER/H225/H245 decoders written in C.]
>
This tool helped me a lot to understand what PER is. Hmm, I thought that 
ethereal is based on openh323 ASN.1 generator which is C++-based. I'll 
take a look at the code later. Is there any free ASN.1 decoder?
I wish I had a better code. I could implement more optimization then. 
For example, if a type after extention mark (...) doesn't have callbacks 
it could be just skiped as open type. I could also try to simplify  
parsing of fixed-length types. May be later I'll find more time to 
rewrite the code.
I forgot to mention that my code is based on 
http://iiiasn1.sourceforge.net (this project AFAIK is derived from 
openh323 decoder/encoder).

--
Alexander Nasonov

PS. Example of generated code:

  void f_MSC__MultimediaSystemControlMessage()
  {
      // CHOICE { < 4 field(s) > ,... }
      size_t len;
      unsigned char* saved_byte;
      unsigned int choice = GetBits3();
      switch(choice)
      {
        case 0:
          f_MSC__MultimediaSystemControlMessage__request();
          break;
        case 1:
          f_MSC__MultimediaSystemControlMessage__response();
          break;
        case 2:
          f_MSC__MultimediaSystemControlMessage__command();
          break;
        case 3:
          f_MSC__MultimediaSystemControlMessage__indication();
          break;
        case 4: case 5: // small number bit is 0
          choice = GetBits5() + ((choice - 4) << 5);
          SkipDataWithSemiConstrainedLength();
          break;
        default: // small number bit is 1
          UngetBits(1);
          SkipDataWithSemiConstrainedLength();
          SkipDataWithSemiConstrainedLength();
          break;
      }
  }
