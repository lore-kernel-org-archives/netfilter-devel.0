From: Piotrek Kaczmarek <kaczorek@k.daleka.net>
Subject: conntrack error
Date: Sat, 12 Feb 2005 12:03:58 +0100
Message-ID: <20050212110358.GA32095@daleka.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
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
I encountered the following situation - when there are around 20000 connections
"cat /proc/net/ip_conntrack" doesn't display all connections and outputs
"cat: No space left on device" error. If I patch kernel with POM and 'nth' module
(only patch, don't load the module) the same happens around 17000 connections.
It happenes both with 2.6.9 and 2.6.10 kernels.

Why is it so? Is this matter of memory limit or something else?

Thank you in advantage,

-- 
Piotrek Kaczmarek
