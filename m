From: "Nikolay S. Rybaloff" <nowhere@hakkenden.ath.cx>
Subject: Re: Troubles with MARK target in 2.6.28
Date: Mon, 12 Jan 2009 21:12:18 +0300
Message-ID: <E60D555B58C140ACA19EAE0DF12DC2F4@Hakkenden>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden> <496AE0E3.1030009@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-15";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <netfilter@vger.kernel.org>,
	"Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>,
	"Jan Engelhardt" <jengelh@medozas.de>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

That did the trick. Both MARK and CONNMARK are working like expected.

--------------------------------------------------
From: "Patrick McHardy" <kaber@trash.net>
Sent: Monday, January 12, 2009 9:19 AM
To: "Nikolay S. Rybalov" <nowhere@hakkenden.ath.cx>
Cc: <netfilter@vger.kernel.org>; "Netfilter Development Mailinglist" 
<netfilter-devel@vger.kernel.org>; "Jan Engelhardt" <jengelh@medozas.de>
Subject: Re: Troubles with MARK target in 2.6.28

> Nikolay S. Rybalov wrote:
>> Hi all,
>>
>> I have troubles with "-j MARK --set-xmark" combination in mangle table.
>> Particulary, I want set one bit in nf mark by means, say, --set-xmark
>> 0x10/0x10, and it worked in kernels from at least 2.6.24 up to the last
>> in 2.6.27.
>>
>> I use: iptables -t mangle -A POSTROUTING -o eth1 -d 192.168.37.0/24 -j
>> MARK --set-xmark 0x10/0x10
>>
>> and get:
>>
>> iptables v1.4.2: Unknown arg `(null)'
>> Try `iptables -h' or 'iptables --help' for more information.
>>
>> When I try --or-mark, iptables says that my "kernel too old 
>> for --or-mark"
>>
>> Same thing happens with -j CONNMARK.
>>
>> Can someone advise what to do, I really need to set only one bit without
>> altering the rest of the mark.
>
> Does this patch fix it?
>
>



> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 89837a4..36cb63b 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -289,6 +289,10 @@ static int target_revfn(u8 af, const char *name, u8 
> revision, int *bestp)
>  have_rev = 1;
>  }
>  }
> +
> + if (af != NFPROTO_UNSPEC && !have_rev)
> + return target_revfn(NFPROTO_UNSPEC, name, revision, bestp);
> +
>  return have_rev;
> }
>
> 
