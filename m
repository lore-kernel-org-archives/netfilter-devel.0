From: Jeremy Kerr <jeremy@redfishsoftware.com.au>
Subject: Re: Netfilter as an application
Date: Sat, 17 Jan 2004 10:00:44 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401171000.44804.jeremy@redfishsoftware.com.au>
References: <20040116194705.905.qmail@web40302.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kernel_learner <kernel_learner@yahoo.com>,
   netfilter-devel@lists.netfilter.org
In-Reply-To: <20040116194705.905.qmail@web40302.mail.yahoo.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


> Basically I want to make a
> version of netfilter that's free from all the
> kernel-level and networking stack hooks. 

The Netfilter Simulation Environment (nfsim) provides exactly that - a 
userspace environment for running and testing netfilter code. It's up at:

http://ozlabs.org/~jk/projects/nfsim/


Jeremy
