From: "cheng long" <kevinclcn@gmail.com>
Subject: structures' names and functions' names of libnetfilter_queue not
	consistent
Date: Wed, 31 May 2006 22:08:12 +0800
Message-ID: <786736460605310708v31f13edbla4a1be2f4b45952f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Hi, All

the structures are named with nfqnl_ prefixs such as "nfqnl_msg_packet_hdr",
however functions are name with nfq_ prefix such as "nfq_get_msg_packet_hdr".

I am often puzzled by that!
Is it possible to make them consistent with each other ?

Thanks!

Regards,
Cheng
