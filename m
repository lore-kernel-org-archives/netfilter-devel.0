From: Claude Biron <claude.biron@shaw.ca>
Subject: MAC Filtering
Date: Tue, 14 Jun 2005 13:55:14 -0700
Message-ID: <001601c57123$5ce2ab00$0a01a8c0@office>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
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

I hope you don't mind asking you a question re: ebtables.   I'm looking to
use ebtables to do MAC filtering in a wireless router in AP mode (default).

The object is to do the following:

 

1.	on router startup, prevent all but the host PC from connecting.
2.	allow a specified MAC to make a connection.
3.	drop/block the MAC at some point in time.  Their current connection
is dropped.

 

The following ebtables commands do not work.  Is there a simple solution?
Many thanks in advance!   Using the linkyss WRT54GS router with SVEASOFT.

 

1.  (on startup block all MACs except one)

ebtables -N check_mac

ebtables -A check_mac -s 00:11:11:B6:A9:21 -j ACCEPT

ebtables -t filter -F INPUT

ebtables -t filter -F FORWARD

ebtables -P INPUT DROP

ebtables -P FORWARD DROP

ebtables -A INPUT --logical-in br0 -j check_mac

ebtables -A FORWARD --logical-in br0 -j check_mac

 

2. (allow a MAC access)

ebtables -A check_mac -s xx:xx:xx:xx:xx:xx -j ACCEPT

 

3. (drop or prevent access)

ebtables -D check_mac -s xx:xx:xx:xx:xx:xx -j ACCEPT


 

 

 
