From: Patrick McHardy <kaber@trash.net>
Subject: Re: [2/2] osf: fixed /proc reading bug
Date: Sun, 22 Aug 2004 02:15:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4127E586.5000707@trash.net>
References: <20040822010358.79048eda@zanzibar.2ka.mipt.ru> <4127CCF9.2030505@trash.net> <Pine.LNX.4.61.0408220142220.21373@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: johnpol@2ka.mipt.ru, Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0408220142220.21373@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:

> On Sun, 22 Aug 2004, Patrick McHardy wrote:
>
>>               log("%s [%s]", f->genre, f->details);
>>
>> -               count += sprintf(buf+count, "%s - %s[%s] : %s",
>> +               err = snprintf(buf+count, __count-count, "%s - %s[%s] 
>> : %s",
>>                                       f->genre, f->version,
>>                                       f->subtype, f->details);
>> -
>> +               if (err < 0)
>
>
> This should read something like follows I think:
>
>           if (err < 0 || err > __count-count)
>
>> +                       break;
>> +               else
>> +                       count += err;
>>               if (f->opt_num)
>>               {
>>                       loga(" OPT: ");
>

Yes, but the check for < 0 is not needed and it should read >= __count - 
count
to avoid useless zero-byte snprintfs. Evgeniy, can you please send a new 
patch ?

>>
>> snprintf returns the number of characters written if n <= limit, 
>> otherwise
>> the number of characters that would have been generated for the given 
>> input,
>> but never < 0. You can also use vscnprintf to get the real number of 
>> bytes
>> written.
>
>
> There may still be systems around with old snprintf implementations 
> returning -1 on overflow unless this is kernel code.

It is. The *nprintf behaviour really is surprising (and annoying for 
chaining
multiple snprintfs), given the behaviour of the *printf functions. OTOH, 
there
is no other way to distinguish "n bytes written" with "truncated to n bytes"
and returning -1 is even worse.

Regards
Patrick
