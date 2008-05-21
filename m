From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 0/2] Security: Add security tables for mandatory access
 control
Date: Thu, 22 May 2008 08:43:48 +1000 (EST)
Message-ID: <Xine.LNX.4.64.0805220842570.8393@us.intercode.com.au>
References: <Xine.LNX.4.64.0805220008510.3033@us.intercode.com.au>
 <alpine.LNX.1.10.0805212359590.15136@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0805212359590.15136@fbirervta.pbzchgretzou.qr>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 22 May 2008, Jan Engelhardt wrote:

> 
> On Wednesday 2008-05-21 16:17, James Morris wrote:
> >
> >In a nutshell, the need for this arises from the fact that MAC labeling 
> >rules utilizing iptables via SECMARK and CONNSECMARK are not subject to 
> >discretionary security policy (i.e. not even "root" or a user with 
> >CAP_NET_ADMIN may be able to modify these rules).
> 
> Yet I do not see any code to possibly prohibit changing the table.

There are calls from SECMARK and CONNSECMARK into the SELinux API, which 
are the labeling targets.


- James
-- 
James Morris
<jmorris@namei.org>
