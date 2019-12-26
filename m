Return-Path: <SRS0=nsnV=2Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DE5C2D0DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Dec 2019 08:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D72352075E
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Dec 2019 08:22:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="F3LJMgGo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfLZIWP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Dec 2019 03:22:15 -0500
Received: from mout.gmx.net ([212.227.17.22]:59767 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbfLZIWP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Dec 2019 03:22:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1577348532;
        bh=HplVyB3V1PdLVixtCKVYnopVrqZ5mZ/CARfPK5jV2fA=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=F3LJMgGohvUvHeBjpE0KAxwc9t/yjk6OocpYJRFo2+2agpSNlL32o4OdSErSdmJVi
         ncAYWnUN0lVIHFmZ6CtyxW+EU38rSEqgxXcZA2tseuao5E1yzxbmdhnA5Nx2Sk6Stq
         jVHrtN+1jy7lwW/tRaLwTjYZwWYOjAVW2wGO5YOw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.3] ([77.116.53.135]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M2f9b-1imJ1H0D7f-0049JD; Thu, 26
 Dec 2019 09:22:12 +0100
Subject: Re: Weird/High CPU usage caused by LOG target
To:     Tom Yan <tom.ty89@gmail.com>, netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org
References: <CAGnHSEkvf0zieVJtPyneZ6PfnzeANmfFxTb=0JpgVb1FXVk0-w@mail.gmail.com>
From:   Thomas Korimort <tomkori@gmx.net>
Autocrypt: addr=tomkori@gmx.net; keydata=
 mQINBFgqyGwBEADvG0Zn05Ctu3EOkgM5cScHLi+EkH9hOwN8Bs99v41l9CrikCVt3OCTf+40
 v04i5OtvPQ9OO7x3idPh49JZ7WYQmKrShDDVV1eTGlQLaNn4o8GElfxJv04uqjClWNlbjUTk
 zn85yBWEFfVJFOFiQWJn6AEvrvZL72Wzkl6zf0zbXXSPtovtwBWEeWpAJG4dgtarOV2D909Y
 y0A6k1tkI46jzcesckjgLN9ldSwYPmaN2n2L3ZuaemPIfsFjuTrre1u+oqq/iRaTVQaks0Xm
 VKnZb9NNrsuOophgwIsjS7hlNa9+UVFB8BTjF3ac3PZeZuqevRxCTZoCkuSGhVL1cy5ELiDl
 pLHCwuVS8O9TVspXTwe2BWNqeud1L6fy7aNNzhR+lJ1fIBinPd24Ow+gaU/rmZg/EHuoZA/M
 jLgEAFkccK299j+Wpd4KeDC+bLqWgzL6KXsTfEOcK8nARaZ6XkjMGm8IQJeOrj223ohJ42Wl
 EOYRWEZYwpopoUePZMe+NETq24Rs+Tp4HxD7k6BHMTeML95Uu5iyFdij3yQI+V9m9MU+hFxw
 EsD4Wg1VIGvMthwGKGLj/2sX/IvSr4YOsbkkxxslQUIZt9DjwnsnxqGd4Vc4l4SHExaUvbCY
 bXw0w0uMeCpNsFo8Qua9LciPibTq1lrvFfJM36jsr7XwJZABBwARAQABtCFUaG9tYXMgS29y
 aW1vcnQgPHRvbWtvcmlAZ214Lm5ldD6JAj8EEwEIACkFAlgqyGwCGyMFCQlmAYAHCwkIBwMC
 AQYVCAIJCgsEFgIDAQIeAQIXgAAKCRA4NCQKHqqcX8o0D/90N8spWWzGVnW3m9LxSUFeYOTF
 EJFyFD3hucmNDD99BCjfVa6jwK97eDk94u/0aYDJIFQ4JMee+/S8HolbRctXGssqgY+a8xr8
 a7ZR+2VSjRniw3Tsr+7qDCvjYV0rwGwwQd8eeDzgDXeyEZpQMELxXWl/iXrc/sbI9Yg626kb
 JByqC4vxiH+8/V/nE64eKAlXMfScAikMhHR8W8Qf0JVAwf1HSdLeguQchTvs0sAouaDpKHeW
 LCopbre2pXrky3mhot5sHqz6X4a6Fr4W5MxnpiSMUQetSdyZWBonXC8g8sxe1Ba82gGZxHcl
 BZZUGAmlnDf8IOSyqoM+FnCHOvPpI9vHRfzLp5to+NbnChUOmfIKKauMjKQqT/3ONe2KanR3
 mCvXlKk3bq82l8jc4Vd5CLgk5d85DfiihnL4nVxiOC2tredTYSMGofh+byivOIp9Hq9mFY06
 MeqmYrqlu/iNS7NUxBbolFaXjoRdGAI+PC5jmWhpacSKxcWQve6lAoDf2UMS2gnjTcxV3XUR
 CGBFLnh+FFAsqjc2OGY+2uQIUJp5C8BvNYafV3osUIienIE9c3qrUdCrjUxXMt5lSrq1aVD2
 pUI6/dZvNqYWU097pGslESsU7V11SbFlHEszgphtZ2KsNmnhpshvdBMBZqpdEU10Mthn6Rf/
 E0lL4DaJZLkCDQRYKshsARAAx0uNApsuow5G0Q+b2apAsZmdMAVqM5hIHy0bEYOV6sV9ykX+
 qQWGfRaSR2bGBJ3OgCHxoVyWJytE94/bpmSQghNQnP4ochUb9cXStwdEAXD2Eib5hnIRqyBy
 hKbW0kBTOhGVGzIKz1Pd0r1E0+SS+kSGYiACnnR6OEJu1IZ5FQ/nFtIYm2cUnbEW1NZq9oF1
 IPB0pnF6GpqW5OmdkNPjsgPfg00r2LiUecjVA1k8ekyB1BcQ/7guNUSKDaJvhGUKgy/ffX07
 VGOt4n+kRDE5IgXeQ/fGzMEnV8HuU9gFy5VHez/+vMETvFDYLCPMkrhbOd+wFg/0JY1GpS1R
 CzkxhgVY33ZfqK6SYziAKEtx05xrwuhGN8+V9PT5ZHHasPHfgwDlSrSEbLytM3GbF4KvWWXH
 21BirR8Zedani+w8dRNpnwGMj/pYEL4z/VJEDSLSjephJPS3fP9GHYR0jU+UzGLc0rNr1bjt
 tKoiY0WF2QeGBUDb2sZ1/Js7XfbtS8KdpKe1FgcEGC/ayrHqwEa44GtHvdcDTMYzEsLykrmB
 yOqEGnIWAIxxVKkwT4QQOU3lXUYal7nkSUSxqYDHXsZDcVSaf8gz7nkWMsFIuAPOjYd2iNGa
 WDocz61+g1CPAS+K9lbLhTBPvtRv3srpUpbzuxSfBJCL/4Be6sjxofuAlgEAEQEAAYkCJQQY
 AQgADwUCWCrIbAIbDAUJCWYBgAAKCRA4NCQKHqqcX0CNEADUv/i/Rstjh7Xm0MQbvOg/om5Z
 SgQhvt2cf5yOPrwRgq01urZsXTibPu9rrQEEnREaqSHE19D/DxRLG53ZElaFz41BXsV8It6A
 FLRxZBL8rDphk641Et+hKkr3AxNqjCpw7sZNS7lYqFFJSrI+X0yOXvyp+JNwxtxvvGcJvqQu
 /hxIEbLX9yU4Rzm1H3JmGsS22/su/SrBDtycFUX5j3trzwcFMoK0hCQJ56YyVmb3MSRmNFWH
 C1S2y4PwRwyrkNF9ToBT/J2UJwdeTXsLsMQdRSnkzXURve2hFpT6xbvzhgHy2krgK7oD0tm9
 OlIkQzzbPNPqYx7NvMdgmgFNfQFoebZ1/mVuER8jqzw6StDmxozGtgk5EPvFK1n8YnNYLCgp
 ikGbQO3V7gsvVBF3fnqH4H36M/kZW8DbFHRoQA6+DWXaB9i/wJNoqT3nsNSKn5qKmL7SPLF+
 7VygOY8Fb9y9QCPmTIrT4pPSsWRNnjaGLppuQsKPha3dMFPzSwGXLuYfhEKLqrESztFiWMyI
 uU83T/yVVDlOWyjQ4F0OyaIdpw4wVX40nDE03xrbJm5LB4Ndv+a5q//87a8NH+YqNTPZNRi4
 m+RtF8pb9oFKgUXDPv2aUwdP951zh6G+xHq7zwWN6OSUzDPWd5p8eME34e7iYCGO38HeBTuU
 eC79Ep3AWQ==
Message-ID: <3158285e-4adf-78fe-cf7b-dca9bef811a0@gmx.net>
Date:   Thu, 26 Dec 2019 09:22:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAGnHSEkvf0zieVJtPyneZ6PfnzeANmfFxTb=0JpgVb1FXVk0-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:MAzGG7w8qBoOKFnu03U12gsPkAiMmZlvrRZVny97pCHWoSmZ2b9
 NMn2Dk1aZV9nxWRge/3j/0Kw5WVeA8C4Thn8Mc9r9sgl9aw3AXD31SLb2YbMoRpwciiZDMS
 NFAHc+3l/dPH5IYkOe+BShQk8oars3SgAgBhQld9l1ke45kXqz7LE8FQgXzyhloBYsagVEX
 koFtSyRGOsBSNdD/tWuVQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:F8nZTeHmJQk=:cU7+O3r59s0CnFZdEWSEqH
 o42cOKnRYIJMZBxBjEEQAcEmw/ykfSn+6Sb+2CPH3t1plw3r80Oe3dVDbeLr+tEtPGZ0MLDpr
 CSPt9b5ICxUp3p6O+d7lhFZIlpYa8OxQtv86r68lG+Dp7fSWTuNtLhs/JT9kD0qe9e/yHFFyI
 a7Nj7Ha8IHZBwuo0hMSDo8hLFMczMUs24O4F1Xcan27EHNnZjBLp5vdPIJUap2qRpwkXKhNsj
 i7FxAcnstVSdLXKHuza/iZML1zZlr8W5ZgxPEGs2Zhl21Hb5lJtSO+wVmP5RIikghZUFvoIpc
 mD9vmQBI35MRYZBlVqMb5wmIxtw37pcB7khBMQMlnFl1MCRe5BamYsgz4ppUSf49/HHLlFJV8
 l+D1eWVMN25Zq7Su4Sy17tBMJHLlCFHR75hSUxeCQC/bICUmjqlyOAKy+aGqSyIGi45OAm89e
 K1uNyacYV7K9JHmouQpwSQABvqwdsI6X8G8Ydl9g2v5eyh5ikZzZg81s07T+g4f4LNdRwwajY
 jEPM8YRpFp2tdYf6yhZGaz08I1wSpRMljHEsB5lSvAKEa2i5OS2m/2sI0cq9CR4u3EA8tJ/jV
 U2UffmzuBdtvj8H3H2Ug7hhd1z4pTYJFoFNhGrCtMD03m6mB0Tnt8mL/KUy6CqpRYroLQWGXV
 jI+5hNEnXYnCX15D6i3LSAQhMtB+5yeJe2zIy3GRlxKiukqcrP/atMhpS9m6DC7t57hPdtR43
 zeLrnFe1YdVM5JXobcrT+KRzplfpHv3lMSqlDz0GfB1IHCFJkXjOE/54C75V3JmJkMOr3OZIl
 wRcUpxkVgA+sQkzR2y5u1K851Wc7eYhMvYrEUMJ84zW0Ke61EpXwXH64IqbU2nxPeS70O98Fa
 gh9Rrv1heh4QCvOo2fkxjxmZ+/wPZW4ICNv5/9YUY0MLBUGqve4TVoSZL4rXncbd+hZS+1yBE
 CBeYKpWLEQwXMdwhyU56Vcz/oIFm2eySuEbSbLMJRcOH/k1/T/DnGdNnMQykHWDfUeRR9NSEX
 EAhlM5qkacnt3plo0rMMcQGatyysM9IXuOJn3yl58eonVnc2FUY5Z9NahXmEjJO/6ZdS/tlaG
 KJkeEjyIYOJbJnbjrgSyvzYqLFY+vMFw6tX0fj+aby430xtMSSs9Kjv0vXbIiokyS3YdfCdko
 quHcl6rHHU1w9y61W0pCK8oAPCMqCAYQ0LoGEx8ymrEGlWttmJvuJAjggr+qYDRLt/siv0RnE
 FPLh1N2sUwYG7XADZNdPPhdmdbBDW5gybrPLOMR1jz/ll3mHrJaVbCK4oY8k=
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi tom yan!

I also noted such a type of CPU usage on my Raspberry Pi 4 4 GB. I have
also found several privacy concerns on my new powerful Raspberry pi 4
4GB. Maybe there are people highjacking CPU power from Raspberry Pis to
do cryptomining or whatever else in terms of distributed
(super)-computing. I am suspecting that the high usability of the
Raspberry Pi 4 4 GB and generally the RPi series imposes a threat to
companies and people who offer high-priced consumer electronics. That is
why we have to experience such kind of issues on our Raspberry Pi
platforms, because a lot of competitors try to push out the RPi
platforms of their business. For example: cost of a modern Smart Tv:
2000 bucks, cost of a similar sized monitor with 4K/2K capability +
self-maintained RPi 4 4GB running Raspbian Buster as a full-fledged
media center: 350 bucks.

During operation of my RPi 4 4 GB i also noticed high CPU peaks. That
was due to not supported x.264 hardware-encoding (now it is supported).
Furthermore, sometimes the RPi4 4GB gets slow. After the update of the
x.264 codec the situation is now relieved. Though sometimes while using
Kodi also strange phenomena occur in terms of slowed down interface
interaction and reaction. That might be related to high CPU load because
of ASCII logging. People underestimate the CPU usage logging features
are making.

Many greetings, Thomas Korimort.

On 26.12.19 04:05, Tom Yan wrote:
> Hi all,
>
> So I was trying to log all traffics in the FORWARD chain with the LOG
> target in iptables (while I say all, it's just some VPN server/client
> that is used by only me, and the tests were just opening some
> website).
>
> I notice that the logging causes high CPU usage (so it goes up only
> when there are traffics). In (h)top, the usage shows up as openvpn's
> if the forwarding involves their tuns. Say I am forwarding from one
> tun to another, each of the openvpn instance will max out one core on
> my raspberry pi 3 b+. (And that actually slows the whole system down,
> like ssh/bash responsiveness, and stalls the traffic flow.) If I do
> not log, or log with the NFLOG target instead, their CPU usage will be
> less than 1%.
>
> Interestingly, the problem seems to be way less obvious if I am using
> it on higher end devices (like my Haswell PC, or even a raspberry pi
> 4). There are still "spikes" as well, but it won't make me "notice"
> the problem, at least not when I am just doing some trivial web
> browsing.
>
> Let me know how I can further help debugging, if any of you are
> interested in fixing this.
>
> Regards,
> Tom
