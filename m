From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH][Netfilter]: forgotten dev_put for bridge-devices in
 nf_reinject() in netfilter.c
Date: Sun, 22 Dec 2002 23:25:24 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021222.232524.42445637.davem@redhat.com>
References: <200212152340.57407.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: bdschuym@pandora.be
In-Reply-To: <200212152340.57407.bdschuym@pandora.be>
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
   Date: Sun, 15 Dec 2002 23:40:57 +0100

   The patch is from Patrick McHardy <kaber@trash.net>.
   
   The problem was caused by the bridge-netfilter patch from me. nf_queue() 
   dev_holds the phys{in,out}dev devices, but nf_reinject() doesn't dev_put() 
   them.

Patch applied, thanks.
