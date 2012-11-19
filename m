From: Ricardo Klein <klein.rfk@gmail.com>
Subject: Re: [ANNOUNCE] ipset 6.15 released
Date: Mon, 19 Nov 2012 16:31:59 -0200
Message-ID: <CADuigkV+d=xvKvKODTyA8avp21ZcL0pY0TjhxAehQi975wkwdQ@mail.gmail.com>
References: <alpine.DEB.2.00.1211191356240.21756@blackhole.kfki.hu>
	<CADuigkXXwhGkjYVCo68BmOGSbe95DzSYcM6u-YQmrjKSD5VWaQ@mail.gmail.com>
	<alpine.LNX.2.01.1211191927160.9275@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1211191927160.9275@nerf07.vanv.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

if  you need, I can deploy a clean CentOS 6.3 64bits and test it again
running autogen with pkg-config installed....
--
Att...

Ricardo Felipe Klein
klein.rfk@gmail.com


On Mon, Nov 19, 2012 at 4:28 PM, Jan Engelhardt <jengelh@inai.de> wrote:
> On Monday 2012-11-19 18:39, Ricardo Klein wrote:
>
>>It fails on ./configure on CentOS 6.3 x84_64 with the message:
>>./configure: line 14702: syntax error near unexpected token `libmnl,'
>>./configure: line 14702: `PKG_CHECK_MODULES(libmnl, libmnl >= 1)'
>
> This means you ran autoreconf (which you normally don't need to, because
> there already is a configure script), while at the same time did not
> have pkg-config installed.
