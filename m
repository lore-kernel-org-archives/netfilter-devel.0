From: Manikandan R <mani.agape@gmail.com>
Subject: Re: Reg:Conntrack-tool for packet dropping?
Date: Thu, 6 Oct 2011 13:37:38 +0530
Message-ID: <CAAG0ft4fFLDA2qTNB5Fhqr7yjPnQEEC+qdNswFmob5j25Li+0w@mail.gmail.com>
References: <CAAG0ft6yyx+PzcvxpfsnCTok7U+cdx3mnsU4gyJMk=zqCOn45A@mail.gmail.com>
	<CAAG0ft4=CaBsdVxKApmvaBhP06xr+1522=Xcwo9O_59zSWunBA@mail.gmail.com>
	<4E8B51AA.7030107@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41076 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab1JFIHk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Oct 2011 04:07:40 -0400
Received: by vcbfk10 with SMTP id fk10so1974972vcb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Oct 2011 01:07:39 -0700 (PDT)
In-Reply-To: <4E8B51AA.7030107@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Ed W,

   Thanks a lot for you reply. Do you mean userspace queues like
libpcap, libnetfilter queue, if not please correct me.

   All my need is to block the application before it establish a
connection with net.

   My initial idea is ,by using libpcap or libnetfilter queue do
packet monitoring and form iptables and block them. But I need to
monitor each and every packets, draw back is before I form iptables
connection will be established by the application.  As we discussed
before, then I go for conntrack, there also i failed.

   Can you please help me on this.

Thanks and Regards,
Manikandan R

On 10/5/11, Ed W <lists@wildgooses.com> wrote:
> On 04/10/2011 15:09, Manikandan R wrote:
>>  Hi,
>>     I am developing application monitoring tool. When I gothru
>> http://netfilter.org/, I come to know about the conntrack-tool which
>> can be used for monitoring new connection.
>>     I used "conntrackd"(conntrack deamon) for monitoring the packets.
>> Using nfct_callback_register2() am able to handle new packets also,
>> but I need to drop this packet if its related to particular
>> pid/process. Is there is any way/api to drop packets?
>>
>
> Conntrack doesn't quite track all packets - see my previous questions
> about this...
>
> I think also if you need to examine all packets and decide their fate
> ahead of allowing them through then you need to look at userspace queue
> stuff?
>
> Note you can setup some extremely clever filtering using iptables. That
> has the ability to filter based on local user id, possibly process id
> and also your app can set firewall marks on each packet that can be
> easily filtered on later?
>
> Good luck
>
> Ed E
>
