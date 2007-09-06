From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/2] Fix (improve) deadlock condition on module removal
 netfilter socket option removal
Date: Thu, 06 Sep 2007 12:33:52 +0200
Message-ID: <46DFD790.6040908@trash.net>
References: <20070904202433.GA19083@hmsreliant.think-freely.org> <46DEC9BF.9010807@trash.net> <1189008806.10802.150.camel@localhost.localdomain> <20070905170831.GA25050@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Rusty Russell <rusty@rustcorp.com.au>, adam@yggdrasil.com,
	jcm@jonmasters.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756316AbXIFKfl@vger.kernel.org>
In-Reply-To: <20070905170831.GA25050@hmsreliant.think-freely.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Neil Horman wrote:
> On Thu, Sep 06, 2007 at 02:13:26AM +1000, Rusty Russell wrote:
> 
>>On Wed, 2007-09-05 at 17:22 +0200, Patrick McHardy wrote:
>>
>>>But I'm wondering, wouldn't module refcounting alone fix this problem?
>>>If we make nf_sockopt() call try_module_get(ops->owner), remove_module()
>>>on ip_tables.ko would simply fail because the refcount is above zero
>>>(so it would fail at point 3 above). Am I missing something important?
>>
>>Yes, that seems the correct solution to me, too.  ISTR that this code
>>predates the current module code.
>>
>>Rusty.
> 
> 
> Thanks guys-
> 	When I first started looking at this problem I would have agreed with
> you, that module reference counting alone would fix the problem.  However,
> delete_module can work in either a non-blocking or a blocking mode.  rmmod
> passes O_NONBLOCK to delete module, and so is fine, but modprobe does not.  So
> if you currently use modprobe -r to remove modules (as the iptables service
> script nominally does), modprobe winds up waiting in the kernel for the module
> reference count to become zero.  Since we can hold a reference to the module
> being removed in the same path that forks a modprobe request to load that same
> module (which then blocks on the first modprobes fcntl lock), we still get
> deadlock.  The way I fixed this was by use of the second patch, which brings
> modprobes behavior into line with the rmmod utility (which is to default to
> non-blocking operation), leading to the remove_module failure and breaking of
> the deadlock that you describe above.


Thanks for the explanation, I've applied your patch.
