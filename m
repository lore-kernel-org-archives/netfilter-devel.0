From: Amin Azez <azez@ufomechanic.net>
Subject: return flow NAT table on POSTROUTING
Date: Mon, 15 May 2006 15:50:53 +0100
Message-ID: <e4a4gh$7jk$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

I've observed on kernel 2.6.11.7 that return flows for SNAT'd
connections do not pass through the NAT chain in the POSTROUTING table.

They do however pass through the MANGLE chain in the POSTROUTING table.

Is this to be expected?

(Of course the original flow did pass through the NAT chain which is how
the SNAT occurred).

Sam
