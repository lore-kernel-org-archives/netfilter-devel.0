From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.12 released
Date: Fri, 11 May 2012 13:45:48 +0100
Message-ID: <4FAD09FC.30707@googlemail.com>
References: <alpine.DEB.2.00.1205101211080.18562@blackhole.kfki.hu>	<alpine.LNX.2.01.1205101238020.20012@frira.vanv.qr>	<alpine.DEB.2.00.1205101316470.18862@blackhole.kfki.hu>	<alpine.LNX.2.01.1205101327310.12733@frira.vanv.qr>	<alpine.DEB.2.00.1205101337160.19028@blackhole.kfki.hu>	<CAMQP0sn=2jKYzoiUVu+oTRYj-niL84Lg2Z1UoO0UnFXJjV8Ggw@mail.gmail.com>	<CAMQP0s=uSzOn-o7jwKLyhTaZud4d04hMN=JXrCQLrFD+6Zinkw@mail.gmail.com>	<alpine.DEB.2.00.1205101724370.19418@blackhole.kfki.hu>	<CAMQP0sm+_8FytQxQHCgk44DVesxMycYQbMW9z+XR0-09NniT9Q@mail.gmail.com>	<CAMQP0snnXgGCJqN1iuN+y9_rgpa7HMrRuM0akhCa-NtxmBz_QA@mail.gmail.com>	<CAMQP0s=DvvYL9SKURz2nm9WuWHQEXBQv9UEQ487GQMwhqa_rgg@mail.gmail.com>	<4FAC3A87.3010500@googlemail.com> <CAMQP0smebRtU8zpjYZTP0EKmOHS=Ncn+iShbcZQdBHnH7ed4bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:32914 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2EKMp5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 May 2012 08:45:57 -0400
Received: by eeit10 with SMTP id t10so961912eei.19
        for <netfilter-devel@vger.kernel.org>; Fri, 11 May 2012 05:45:55 -0700 (PDT)
In-Reply-To: <CAMQP0smebRtU8zpjYZTP0EKmOHS=Ncn+iShbcZQdBHnH7ed4bw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> However I'm working on the "ipset_hash_iplookup" which is proposed to
> be used with "SETRAWNAT" target.
> Both are my experimental ipset type and iptables/xtables target
> respectively. No problems for SETRAWNAT as the iptables/xtables
> provides the dynamic module loading support already.
>   
I don't suppose you are working on ways to include ipset targets in tc 
by any chance, are you? *hopeful look*
