From: =?ISO-8859-1?Q?S=E9bastien_Bernard?= <seb@frankengul.org>
Subject: rp-pppoe.so broke netfilters
Date: Fri, 21 Oct 2005 20:01:41 +0200
Message-ID: <43592D05.1010302@frankengul.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

As I mentionned in my post in netfilter-user ML,
the pppoe kernel module used conccurently with rp-pppoe.so breaks the 
NAT filtering in a subtle way.

I can't figure why (well I didn't look to tell the truth).

I suspect some shortcut used by pppoe that forgot to call the netfilter 
hooks somewhere.

My 2 cents contrib.

  Seb
