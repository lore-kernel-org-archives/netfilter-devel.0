From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: Fixed small memory leak into ipt_geoip.c
Date: Thu, 16 Dec 2004 21:56:04 -0500
Message-ID: <41C24AC4.8020709@cookinglinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Nicolas Bouliane <nib@cookinglinux.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi there,

The subject said it all, I was allocating memory for a 
checkentry()/destroy() refcount
but not freeing it..

Current code can be retreived from :
svn co http://svn.cookinglinux.org/netfilter/geoip/trunk

Bug discovered with nfsim, the netfilter developer's favorite toy.

See ya,

--peejix
