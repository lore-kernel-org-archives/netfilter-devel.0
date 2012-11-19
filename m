From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ANNOUNCE] ipset 6.15 released
Date: Mon, 19 Nov 2012 19:28:09 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211191927160.9275@nerf07.vanv.qr>
References: <alpine.DEB.2.00.1211191356240.21756@blackhole.kfki.hu> <CADuigkXXwhGkjYVCo68BmOGSbe95DzSYcM6u-YQmrjKSD5VWaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Ricardo Klein <klein.rfk@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <CADuigkXXwhGkjYVCo68BmOGSbe95DzSYcM6u-YQmrjKSD5VWaQ@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Monday 2012-11-19 18:39, Ricardo Klein wrote:

>It fails on ./configure on CentOS 6.3 x84_64 with the message:
>./configure: line 14702: syntax error near unexpected token `libmnl,'
>./configure: line 14702: `PKG_CHECK_MODULES(libmnl, libmnl >= 1)'

This means you ran autoreconf (which you normally don't need to, because 
there already is a configure script), while at the same time did not 
have pkg-config installed.
