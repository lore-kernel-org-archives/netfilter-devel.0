From: Mike-Ro-Chanel <mikerochanel@yahoo.it>
Subject: Mutex question in iptables
Date: Mon, 25 Aug 2003 11:54:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F49DCDB.4080804@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Hi All,
a simple question for a match module writing:

Is "checkentry()" and "destroy()" mutex granted by 'ipt_mutex" semaphore?

Regards.

                Mike-Ro-Chanel
