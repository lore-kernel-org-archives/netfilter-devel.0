From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Orphaned expectations
Date: Sun, 25 Apr 2004 02:25:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <408B0587.8040702@trash.net>
References: <20040419203744.GA1328@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040419203744.GA1328@linuxace.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:
> So we need to make sure that expectations don't get orphaned in this way, which
> I believe the below patch will ensure.  Of course it will also stop the
> oops on read of /proc/net/ip_conntrack.

Thanks Phil, I've added this patch to CVS:

@@ -324,8 +324,9 @@
                 ip_conntrack_destroyed(ct);

         WRITE_LOCK(&ip_conntrack_lock);
-       /* Delete us from our own list to prevent corruption later */
-       list_del(&ct->sibling_list);
+       /* Make sure don't leave any orphaned expectations lying around */
+       if (ct->expecting)
+               remove_expectations(ct, 1);

         /* Delete our master expectation */
         if (ct->master) {

Regards,
Patrick
