From: Richard Liu <richardliu@ms1.techarea.org>
Subject: How to change source port in MASQUERADE mode?
Date: Fri, 30 Sep 2005 12:36:48 +0800
Message-ID: <433CC0E0.5060308@ms1.techarea.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Hi,
I have a question about change tuple source port.
I have a nat device, and I want this device can change tuple source port
in some special conditions (not always).

I want change tuple source port in MASQUERADE module.

for example:
    Destination                Gateway                Source
    DA(Ipaddr):Port          GA:Port                SA:Port

In Masquerade modules
                                    src:GA:1000           src:SA:1000
                                    dst:DA:23               dst:DA:23

But I want to the src port be changed in some conditions like this.
                                    src:GA:50000+1000  src:SA:1000
                                    dst:DA:23               dst:DA:23

I am tracing source few days, but I still don't know which function
allocate tuple source port.
Does anyone can give me some hints, I am very appreciate.
