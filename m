From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 0/2] Security: Add security tables for mandatory access
 control
Date: Mon, 26 May 2008 19:12:58 +1000 (EST)
Message-ID: <Xine.LNX.4.64.0805261911000.3470@us.intercode.com.au>
References: <Xine.LNX.4.64.0805220008510.3033@us.intercode.com.au>
 <alpine.LNX.1.10.0805212359590.15136@fbirervta.pbzchgretzou.qr>
 <Xine.LNX.4.64.0805220842570.8393@us.intercode.com.au>
 <alpine.LNX.1.10.0805221756520.9332@fbirervta.pbzchgretzou.qr>
 <Xine.LNX.4.64.0805261755340.3470@us.intercode.com.au>
 <alpine.LNX.1.10.0805261020390.19084@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0805261020390.19084@fbirervta.pbzchgretzou.qr>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 26 May 2008, Jan Engelhardt wrote:

> In fact, there is not even really a per-rule [rule={match,target}]
> destroy function. A new table image is loaded and atomically
> swapped with the previous one. You would rather want to call
> security_*() in the ioctl phase.

It's possible the existing coarse-grained capability check that SELinux 
hooks into (cap_net_admin) is enough for rule deletion, given that we 
don't know the ultimate effect of deleting rules.  i.e. there may be no 
point in trying to further decompose that privilege.


- James
-- 
James Morris
<jmorris@namei.org>
