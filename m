From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH/RFC] Add arptables mangle module
Date: Wed, 25 Jun 2003 21:50:08 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030625.215008.85411137.davem@redhat.com>
References: <200306252056.31153.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: bdschuym@pandora.be
In-Reply-To: <200306252056.31153.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Bart De Schuymer <bdschuym@pandora.be>
   Date: Wed, 25 Jun 2003 20:56:31 +0200

   I've added protocol length checking, since this is useful for
   bridged arp packets. It's useless for non-bridged packets though.

This is going to break any user tools people might be using.
Please delete this part of the patch so we can discuss it
seperately.

I have no problem with the mangle module addition.
