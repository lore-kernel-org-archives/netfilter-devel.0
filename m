From: =?ISO-8859-2?Q?Tom=E1=B9_Lejdar?= <tomas.lejdar@i.cz>
Subject: libiptc memory leak - PATCH
Date: Tue, 22 Apr 2003 00:25:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA46FDE.6040806@i.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,
I've used libiptc for some utils and found a little
problem with memory allocation, discused in January and
may be earlier. Here is a small patch (r.1.2.8):

*** libiptc/libiptc.c.orig      Mon Apr 21 23:54:48 2003
--- libiptc/libiptc.c   Mon Apr 21 23:59:30 2003
***************
*** 504,511 ****
         (*handle)->cache_chain_iteration++;

         if ((*handle)->cache_chain_iteration - (*handle)->cache_chain_heads
!           == (*handle)->cache_num_chains)
                 return NULL;

         return (*handle)->cache_chain_iteration->name;
   }
--- 504,513 ----
         (*handle)->cache_chain_iteration++;

         if ((*handle)->cache_chain_iteration - (*handle)->cache_chain_heads
!           == (*handle)->cache_num_chains){
!                 free((*handle)->cache_chain_heads);
                 return NULL;
+       }

         return (*handle)->cache_chain_iteration->name;
   }

T.v.L
