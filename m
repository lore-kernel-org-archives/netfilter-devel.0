From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] NAT handles non-linear skbs
Date: Tue, 06 May 2003 05:28:37 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030506.052837.51687210.davem@redhat.com>
References: <20030506110129.GD14822@sunbeam.de.gnumonks.org>
	<20030506.030538.124071859.davem@redhat.com>
	<20030506131614.GE14822@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, jmorris@intercode.com.au,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20030506131614.GE14822@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Harald Welte <laforge@netfilter.org>
   Date: Tue, 6 May 2003 15:16:14 +0200
   
   Well, if we are going for the copy_bits() solution, we obviously don't
   want to have every match/target create it's own copy of the bits of data
   it needs.

All the copies go to the local stack, it's really fast.

I think trying to generalize this is a bad idea, the whole
value in this whole scaffolding in netfilter is that it can
work with anything.

Look at it this way, think about what you'd have to do to
pass around "TCP header will be needed".  What if all my machine
does is UDP stuff :-)
