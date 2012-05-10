From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.12 released
Date: Thu, 10 May 2012 23:00:39 +0100
Message-ID: <4FAC3A87.3010500@googlemail.com>
References: <alpine.DEB.2.00.1205101211080.18562@blackhole.kfki.hu>	<alpine.LNX.2.01.1205101238020.20012@frira.vanv.qr>	<alpine.DEB.2.00.1205101316470.18862@blackhole.kfki.hu>	<alpine.LNX.2.01.1205101327310.12733@frira.vanv.qr>	<alpine.DEB.2.00.1205101337160.19028@blackhole.kfki.hu>	<CAMQP0sn=2jKYzoiUVu+oTRYj-niL84Lg2Z1UoO0UnFXJjV8Ggw@mail.gmail.com>	<CAMQP0s=uSzOn-o7jwKLyhTaZud4d04hMN=JXrCQLrFD+6Zinkw@mail.gmail.com>	<alpine.DEB.2.00.1205101724370.19418@blackhole.kfki.hu>	<CAMQP0sm+_8FytQxQHCgk44DVesxMycYQbMW9z+XR0-09NniT9Q@mail.gmail.com>	<CAMQP0snnXgGCJqN1iuN+y9_rgpa7HMrRuM0akhCa-NtxmBz_QA@mail.gmail.com> <CAMQP0s=DvvYL9SKURz2nm9WuWHQEXBQv9UEQ487GQMwhqa_rgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42416 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760746Ab2EJWAq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 May 2012 18:00:46 -0400
Received: by wgbdr13 with SMTP id dr13so1897812wgb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 May 2012 15:00:45 -0700 (PDT)
In-Reply-To: <CAMQP0s=DvvYL9SKURz2nm9WuWHQEXBQv9UEQ487GQMwhqa_rgg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> the point of this feature is providing the easy way that the
> third-party or the experimental modules
> plug into the existing ipset userspace binary without recompile.
>
> You could build the experimental ipset "FOO" kernel module and build
> the shared-lib of "FOO" userspace tool module and
> plug into the system without recompile the ipset userspace tool at
> all. It's inspired by iptables (kernel/userspace module).
>   
Is there a documentation on how to do that? For example, if I wish to 
add my own ipset type/matching (as a separate module), where do I start 
looking?

