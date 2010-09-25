From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/6] secmark: export binary yes/no rather than kernel
 internal	secid
Date: Sat, 25 Sep 2010 10:41:50 +0200
Message-ID: <4C9DB5CE.7090305@netfilter.org>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com> <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
	netfilter-devel@vger.kernel.org, jmorris@namei.org,
	sds@tycho.nsa.gov, jengelh@medozas.de, paul.moore@hp.com,
	casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
	netfilter@vger.kernel.org, mr.dash.four@googlemail.com
To: Eric Paris <eparis@redhat.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 24/09/10 22:45, Eric Paris wrote:
> Currently the nfconntrack export code sends the kernel internal secid to
> userspace in a couple of proc files and over netlink as an integer.  This
> is wrong.  This number is a kernel internal.  This patch changes the export
> code to output either 0 or 1 for this value.  A future patch will implement
> sending the name rather than the number in a new field.

I'm not sure why you need this transitional patch if you later on
replace it.

Better to change the /proc output to make it consistent with patch 5/6?
