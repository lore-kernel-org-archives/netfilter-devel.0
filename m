From: mqe <mqe@usr.fi>
Subject: CONNMARK kernel 2.6
Date: Fri, 12 Mar 2004 15:21:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4051B95D.7010506@usr.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

Hello

Has someone been able to use CONNMARK match succesfully on 2.6 kernels?
For me the module and iptables compiles just fine, but when trying to 
use --match connmark it says:

iptables: No chain/target/match by that name

- Mike
