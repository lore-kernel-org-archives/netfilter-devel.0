From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Netfilter Packet Reinjection
Date: Sat, 24 Mar 2012 22:31:04 +0100
Message-ID: <20120324213104.GA30268@1984>
References: <CAMpo4z2HumFBL+xNWPKbJiUancfraKT2_+u=fqkzSOX-74t8jg@mail.gmail.com>
 <471DE477E2B1F549A58F3A14A27180BE014CC0@HQ-EX01.bytemobile.com>
 <CAMpo4z0gLyYa6xnZHYSz8Z4q98aan_uv_z73o4Wwc0UV=5m2Lg@mail.gmail.com>
 <471DE477E2B1F549A58F3A14A27180BE014CD8@HQ-EX01.bytemobile.com>
 <CAMpo4z2YMZDv1vAAevK1Q_k37nCPhZpuLAvErK5O8BN0mbaZgw@mail.gmail.com>
 <alpine.LNX.2.01.1203232355300.32477@frira.zrqbmnf.qr>
 <CAMpo4z1kGLWbfuoSnBx=_ECDWB15TxR1v50CwO+6+hjJQw72kg@mail.gmail.com>
 <alpine.LNX.2.01.1203240005020.4134@frira.zrqbmnf.qr>
 <CAMpo4z0GcztvVUCDR7Ay97Z=LTB-=JFnV_dNtw4__u1YEKTeSQ@mail.gmail.com>
 <CAMpo4z0GRn7WD+4K+2EA1EbvKsvP+Ohu1i1PTSNkKHe0rBwiTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Jeff Haran <jharan@bytemobile.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Fr3DBr <fr3dbr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33192 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab2CXVbK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Mar 2012 17:31:10 -0400
Content-Disposition: inline
In-Reply-To: <CAMpo4z0GRn7WD+4K+2EA1EbvKsvP+Ohu1i1PTSNkKHe0rBwiTA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 24, 2012 at 05:20:01PM -0300, Fr3DBr wrote:
> Hey,
> 
> i've been trying this, but it seens as soon i call NF_HOOK, the whole
> thing freezes, like if it entered in a infinite loop, i tried adding
> some sanity check to avoid 'recursive' looping and it seemed to avoid
> this scenario, but now it just freezes and only resetting the OS put
> it back to work (since it wont load the module)...
> 
> Any ideas ?!

Please, stop top-posting.

Someone already told you this before and you seem to ignore that.

Read Netfilter mailing list rules:
http://www.netfilter.org/mailinglists.html

Moreover, if you want help it would be a good idea if:

a) you post your code somewhere.

b) you reduce the amount of emails for every single issue that you
find while trying to learn how things. People may end up ignoring you
if you become too spamming. Making questions is fine, don't abuse.
