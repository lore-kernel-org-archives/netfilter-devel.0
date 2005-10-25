From: Nhan Thanh Le <ltnhan@tma.com.vn>
Subject: What's happen if two module hook the same hook?
Date: Tue, 25 Oct 2005 10:52:17 +0700
Message-ID: <435DABF1.7000607@tma.com.vn>
References: <200510220754.j9M7s1gx028191@mail.tma.com.vn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200510220754.j9M7s1gx028191@mail.tma.com.vn>
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

Dear All,

   I am writing a kernel module to reading packet travel via my network 
using Netfilter hook function. I wonder what's happen if in kernel space 
already exist one module hook into netfilter with the same hook number 
(NF_IP_PRE_ROUTING) with my module and that module try to drop all 
packets while my module try to reading that packet.  Does it conflict 
situation? Could you please help me to understand this case?  Do we  
have any solution to solve for this case?

    What's different between using socket raw and netfilter hook function?

Best Regards,
Nhanle
