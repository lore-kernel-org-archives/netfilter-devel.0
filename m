From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 0/2] Security: Add security tables for mandatory access
 control
Date: Mon, 26 May 2008 18:06:15 +1000 (EST)
Message-ID: <Xine.LNX.4.64.0805261755340.3470@us.intercode.com.au>
References: <Xine.LNX.4.64.0805220008510.3033@us.intercode.com.au>
 <alpine.LNX.1.10.0805212359590.15136@fbirervta.pbzchgretzou.qr>
 <Xine.LNX.4.64.0805220842570.8393@us.intercode.com.au>
 <alpine.LNX.1.10.0805221756520.9332@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="927316971-1634477206-1211789175=:3470"
Cc: netfilter-devel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from namei.org ([69.55.235.186]:45384 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753463AbYEZIGa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 May 2008 04:06:30 -0400
In-Reply-To: <alpine.LNX.1.10.0805221756520.9332@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--927316971-1634477206-1211789175=:3470
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 22 May 2008, Jan Engelhardt wrote:

> 
> On Thursday 2008-05-22 00:43, James Morris wrote:
> >On Thu, 22 May 2008, Jan Engelhardt wrote:
> >> On Wednesday 2008-05-21 16:17, James Morris wrote:
> >> >
> >> >In a nutshell, the need for this arises from the fact that MAC labeling 
> >> >rules utilizing iptables via SECMARK and CONNSECMARK are not subject to 
> >> >discretionary security policy (i.e. not even "root" or a user with 
> >> >CAP_NET_ADMIN may be able to modify these rules).
> >> 
> >> Yet I do not see any code to possibly prohibit changing the table.
> >
> >There are calls from SECMARK and CONNSECMARK into the SELinux API, which 
> >are the labeling targets.
> 
> But you cannot deny the deletion of a rule from within SECMARKÿÿ
> there is not even a ->destroy function in that module.

There is a destroy function, although it is only used internally by 
SELinux for reference counting.

The xtables destroy method does not return a value and probably needs to 
unconditionally succeed in any case.

Possible solutions are:

- Add a new method which is designed specifically for applying access 
control to rule deletion.

- Add a flag to the table struct which indicates that an LSM hook should 
be called, which can then be used for all table manipulation on a coarse 
level (e.g. invoke "cap_mac_admin" or "load_policy" permission, or 
similar).


Note that coarse-grained control over deletion may be preferable, as we 
don't really know what effect the deletion will have (e.g. the packets may 
fall through to another rule which the user should not have been able to 
specify).



- James
-- 
James Morris
<jmorris@namei.org>
--927316971-1634477206-1211789175=:3470--
