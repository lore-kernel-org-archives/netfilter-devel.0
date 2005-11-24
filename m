From: Diego Cabrero <diego.cabrero@e-attico.net>
Subject: iptables IMQ command problem
Date: Thu, 24 Nov 2005 13:32:43 +0100
Message-ID: <4385B2EB.60209@e-attico.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi everybody,
Here is my situation:
First of all, i need control over the downlink bandwith, so i patched 
kernel (2.4.28), iptables (1.2.11) so that i get IMQ support (imq0 and 
imq1), but when i run the traffic control script i've got an error on 
this line:

iptables -t mangle -A PREROUTING -i eth1 -j IMQ --todev 0

The error report is:
iptables v1.2.11: Unknown arg `--todev'
Try `iptables -h' or 'iptables --help' for more information.
RTNETLINK answers: Invalid argument
RTNETLINK answers: No such file or directory
RTNETLINK answers: No such file or directory

I've tried a lot of things like change the file's ".IMQ-test" mode , 
check if todev variable exist (it does), don't know what could be next, 
i'd appreciate some help.

Thanks.
