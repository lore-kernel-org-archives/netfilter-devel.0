From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: TCP window tracking has bad side effects
Date: Wed, 1 Dec 2004 12:02:55 +0100
Message-ID: <20041201110253.GA9536@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

Recent state matching code apparently added some kind of TCP window
tracking which marks out of sequence packets as INVALID.

Previously one could use some minimal filter rules like this on a
client machine:

iptables -F 
iptables -X 
iptables -P INPUT DROP 
iptables -P FORWARD DROP 
iptables -P OUTPUT ACCEPT 
iptables -A INPUT -j ACCEPT -i lo 
iptables -A INPUT -j ACCEPT -m state --state ESTABLISHED,RELATED 


With TCP window tracking those rules no longer work for services
that use fixed ports (e.g. NFS) and one side crashes or terminates
the connection in other ways without notifying the peer (e.g. link
down). When the crashed machine comes up again and tries to
reestablish the connection it sends a SYN. The remote end finds that
confusing and replies with an ACK as probe. Since that ACK does not
fit any window it's discarded as INVALID. The remote side can now
sit there forever sending ACKs and no new connection can be
established. Previously, without window tracking, the ACK was
accepted and answered with RST, the remote closed the connection and
a new one could be established. 

Is there a way to disable the window tracking and revert to the old
behavior?

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   SUSE LINUX AG, Development
 V_/_  http://www.suse.de/
