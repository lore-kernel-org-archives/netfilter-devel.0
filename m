From: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
Subject: status of nf-HIPAC integration ?
Date: Mon, 21 Aug 2006 16:57:20 +0200
Message-ID: <20060821145720.GA749@ekonomika.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kulnet@kulnet.kuleuven.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, mbellion@hipac.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

for some time now we have been using the nf-HIPAC patch in our firewalls' kernels
and I'm glad to say it works nicely. Our firewalls still run 2.4.x kernels. Ever 
since the introduction of x-tables in the 2.6.x branch, the nf-HIPAC patch no 
longer applies.

I found a patch at 
http://www.kernelproject.org/people/jhpark/nf-hipac-0.9.1-to-linux-2.6.16.16.patch
by Jeho-Park, which should allow me to compile 2.6.16.16 with nf-HIPAC. 

Has anyone tried this patch ?

I'm not sure what the future of nf-HIPAC is. I'd like it very much if the 
mainstream kernel came with nf-HIPAC by default, but I see no indications that 
anything is moving in that direction.

Is nf-HIPAC still being worked on ?
Is it still on the TODO-list to integrate nf-HIPAC into the mainstream kernel ?

kind regards,
-- Steven Van Acker

-- 
My amazon wishlist:
http://www.amazon.com/gp/registry/1DB4XNEIEQBPB
