From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Accumulated fixes v2
Date: Thu, 31 Jan 2013 10:41:21 +0100
Message-ID: <20130131094121.GD6167@localhost>
References: <1359381586-11940-1-git-send-email-jengelh@inai.de>
 <alpine.LNX.2.01.1301310313210.5099@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:53261 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751408Ab3AaJl0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:41:26 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1301310313210.5099@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 31, 2013 at 03:13:32AM +0100, Jan Engelhardt wrote:
> On Monday 2013-01-28 14:59, Jan Engelhardt wrote:
> 
> >----------------------------------------------------------------
> >Jan Engelhardt (6):
> >      build: also use libtool for install stage
> >      build: do not dereference symlinks on installation
> >      libxtables: centralize checking for a .save function
> >      extensions: eui64: set userspacesize=0
> >      iptables: fall back to using save function when print is not defined
> >      iptables: reword warning on using an alias
> 
> Any disposition on this?

Jozsef's patchset is more important at this moment. Once those
applied, I'll look again into these.
