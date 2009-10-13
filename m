From: arulgobinath emmanuel <arulgobi@gmail.com>
Subject: Re: Doubts in netfilter limit match
Date: Tue, 13 Oct 2009 23:16:51 +0530
Message-ID: <6f3802e80910131046j27bd2488g7b7f98d799ed3e54@mail.gmail.com>
References: <52072.152.14.243.6.1255454246.squirrel@webmail.ncsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Balaji Venkatamohan <bvenkat@ncsu.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:64903 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760403AbZJMRr7 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Oct 2009 13:47:59 -0400
Received: by qw-out-2122.google.com with SMTP id 9so955742qwb.37
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2009 10:46:52 -0700 (PDT)
In-Reply-To: <52072.152.14.243.6.1255454246.squirrel@webmail.ncsu.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I'm not an expert in netfilter & new to this mailing-list also :) but
i had come across a situation to defend against DDOS using iptables.
I used recent module
"if the one host create more than 20 session during 100 seconds drop
the packet."

iptables -I FORWARD -p tcp --dport 80 -i bridge0 -m state --state NEW
-m recent --set
iptables -I FORWARD -p tcp --dport 80 -i bridge0 -m state --state NEW
-m recent --update --seconds 100 --hitcount 20 -j DROP

source code:
http://www.il.is.s.u-tokyo.ac.jp/lxr-xp/source/net/netfilter/xt_recent.=
c
(other netfilter code also available )

The hit file saved here :
/proc/net/xt_recent/DEFAULT

I hope this will help you .

Regards,
Gobinath.



On Tue, Oct 13, 2009 at 10:47 PM, Balaji Venkatamohan <bvenkat@ncsu.edu=
> wrote:
> Hi,
>
> I want to know how the limit match works. When we are trying to restr=
ict
> the number of packets sent by a particular IP to, say, 3 / hour, we u=
se a
> iptable rule like
>
> =A0 =A0 =A0 =A0iptables -A INPUT -s 127.0.0.1 -m limit --limit-burst =
5
>
> I want to know how and where the count is stored. Are they checked fo=
r
> previous entries using netfilter log? Also, Can you please tell me th=
e .c
> file in the netfilter source code which deals with handling various m=
atch
> and target extensions. If you can send me a link to any tutorial that
> deals with linux network programming then that will be great.
>
> Thanks and Regards,
> Balaji
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
