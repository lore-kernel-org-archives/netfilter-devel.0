From: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 3/6] secmark: export binary yes/no rather than kernel
 internal	secid
Date: Mon, 27 Sep 2010 12:44:05 -0400
Message-ID: <1285605845.2815.7.camel@localhost.localdomain>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>
	 <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>
	 <4C9DB5CE.7090305@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
	netfilter-devel@vger.kernel.org, jmorris@namei.org,
	sds@tycho.nsa.gov, jengelh@medozas.de, paul.moore@hp.com,
	casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
	netfilter@vger.kernel.org, mr.dash.four@googlemail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4C9DB5CE.7090305@netfilter.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2010-09-25 at 10:41 +0200, Pablo Neira Ayuso wrote:
> On 24/09/10 22:45, Eric Paris wrote:
> > Currently the nfconntrack export code sends the kernel internal secid to
> > userspace in a couple of proc files and over netlink as an integer.  This
> > is wrong.  This number is a kernel internal.  This patch changes the export
> > code to output either 0 or 1 for this value.  A future patch will implement
> > sending the name rather than the number in a new field.
> 
> I'm not sure why you need this transitional patch if you later on
> replace it.
> 
> Better to change the /proc output to make it consistent with patch 5/6?

Jan has stated his opinion I should not export the new secctx field via
the procfs interface.  This patch was included in the series in case
that was the consensus of the lists and thus we just wouldn't apply
patch 6/6 (which drops secmark and adds secctx to procfs)

-Eric

