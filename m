From: Pablo Neira <pablo@eurodev.net>
Subject: locking issue in ip_conntrack_alter_reply
Date: Fri, 30 Apr 2004 19:09:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40928861.2010902@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Patrick McHardy <kaber@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi everyone,

I submitted a patch for a similar issue not a long time ago. See:

http://lists.netfilter.org/pipermail/netfilter-devel/2004-March/014764.html

Well, actually I found a contradiction here, we write-locked the 
conntrack table but that assertion says that this conntrack is not 
confirmed, this implies that the conntrack is not in the hash table yet. 
If that assertion is right, we should replace that write_lock for a 
read_lock while calling __ip_conntrack_find and remove that write_lock 
at the end of the function.

int ip_conntrack_alter_reply(struct ip_conntrack *conntrack,
                             const struct ip_conntrack_tuple *newreply)
{
        WRITE_LOCK(&ip_conntrack_lock);
        if (__ip_conntrack_find(newreply, conntrack)) {
                WRITE_UNLOCK(&ip_conntrack_lock);
                return 0;
        }
        /* Should be unconfirmed, so not in hash table yet */
        IP_NF_ASSERT(!is_confirmed(conntrack)); <--------------------------


I'll study if that assertion is right before submitting a patch. 
Feedback is always welcome :-).

regards,
Pablo
