From: leon_tseng@wneweb.com.tw
Subject: Need help!
Date: Fri, 14 Jan 2005 17:37:20 +0800
Message-ID: <48256F89.0033D793.00@TWWNCDS1.WNEWEB.COM.TW>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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



Currently, i am implementing isakmp/ike nat helper. As isakmp always uses source
port 500, destination port 500. After the first connection is established, the
second connection's source port will be changed to another port. How can i make
nelfilter not to change the source port? Currently my idea is to demultiplex the
connection through isakmp icookie/rcookie.  How to achieve this? Thanks. Your
help will be appreciated.
