From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/2] Fix (improve) deadlock condition on module removal
	netfilter socket option removal
Date: Thu, 06 Sep 2007 02:13:26 +1000
Message-ID: <1189008806.10802.150.camel@localhost.localdomain>
References: <20070904202433.GA19083@hmsreliant.think-freely.org>
	 <46DEC9BF.9010807@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>, adam@yggdrasil.com,
	jcm@jonmasters.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932450AbXIEQOK@vger.kernel.org>
In-Reply-To: <46DEC9BF.9010807@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2007-09-05 at 17:22 +0200, Patrick McHardy wrote:
> But I'm wondering, wouldn't module refcounting alone fix this problem?
> If we make nf_sockopt() call try_module_get(ops->owner), remove_module()
> on ip_tables.ko would simply fail because the refcount is above zero
> (so it would fail at point 3 above). Am I missing something important?

Yes, that seems the correct solution to me, too.  ISTR that this code
predates the current module code.

Rusty.
