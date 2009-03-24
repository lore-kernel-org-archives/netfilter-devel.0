From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [ANNOUNCE] Xtables-addons 1.13 released
Date: Tue, 24 Mar 2009 13:27:01 +0800
Message-ID: <412e6f7f0903232227rd1fe891xaf90b0bc1bc67748@mail.gmail.com>
References: <alpine.LSU.2.00.0903231816540.25130@fbirervta.pbzchgretzou.qr>
	 <20090323134327.35e9a8dc@liberty.rlwhome.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Robby Workman <rw@rlworkman.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20090323134327.35e9a8dc@liberty.rlwhome.lan>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

When reviewing the code, I found there maybe a bug in libxt_fuzzy.c.
If an user want to delete this match module, he will got an error
reporting, and faile. As the fileds after maximum_rate in
xt_fuzzy_mtinfo will be altered in kernel space, we should assign the
userspacesize with the value offsetof(struct xt_fuzzy_mtinfo,
packets_total) instead.

On Tue, Mar 24, 2009 at 2:43 AM, Robby Workman <rw@rlworkman.net> wrote:
> On Mon, 23 Mar 2009 19:17:43 +0100 (CET)
> Jan Engelhardt <jengelh@medozas.de> wrote:
>
>> Overview: http://freshmeat.net/projects/xtables-addons/
>> src (for the quick ones):
>>   http://downloads.sf.net/xtables-addons/xtables-addons-1.13.tar.bz2
>>
>> This release adds a reworked version of the "ipv4options" match, and
>> works with the recently-released iptables 1.4.3.
>>
>> (1.4.3 is a hard minimum requirement now.)
>
>
> Thanks, Jan.  Built and working just fine here, best I can tell.
>
> -RW
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
