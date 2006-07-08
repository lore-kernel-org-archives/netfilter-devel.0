From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_recent: add module parameter for changing GID of
 /proc/net/ipt_recent/*
Date: Sat, 08 Jul 2006 05:02:55 +0200
Message-ID: <44AF205F.3070600@trash.net>
References: <44AF0E7E.70507@iastate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Daniel De Graaf <danield@iastate.edu>
In-Reply-To: <44AF0E7E.70507@iastate.edu>
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

Daniel De Graaf wrote:
> This patch adds an ip_list_gid module parameter to ipt_recent, which is
> meant to be used in combination with the ip_list_perms. In the current
> implementation, the files must either be world-writable or require
> programs which write to them to be (at least) setgid root.
> 
> - Daniel De Graaf

 /* Structure of our list of recently seen addresses. */
 struct recent_ip_list {
@@ -852,6 +855,7 @@
 	}
 	
 	curr_table->status_proc->owner = THIS_MODULE;
+	curr_table->status_proc->gid = ip_list_gid;
 	curr_table->status_proc->data = curr_table;
 	wmb();
 	curr_table->status_proc->read_proc = ip_recent_get_info;


That code is gone for good, please check if your patch is still
necessary for current -git and resubmit in case it is.
