From: Diego Cabrero <diego.cabrero@e-attico.net>
Subject: Re: iptables IMQ command problem
Date: Thu, 24 Nov 2005 16:17:16 +0100
Message-ID: <4385D97C.4070201@e-attico.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Artur Szczurzynski <Artur.Szczurzynski@pl.initiative.com>,
	netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
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

Is it not supposed to be installed since imq0 and imq1 are working?

Also i compiled kernel choosing IMQ device module option. Insmod the 
imq.o driver as well, but still does not work. There must be something else.

Here is the list of modules loaded while i execute the command.


Module                  Size  Used by    Not tainted
------------------------------------------------
ipt_IMQ                  824   0  (unused)
imq                        1140   0  (unused)
cls_fw                    2520   1  (autoclean)
ipt_MARK              760   2  (autoclean)
sch_htb                20928   3  (autoclean)
8139too               13768   1
mii                          2464   0  [8139too]
crc32                      2912   0  [8139too]
e100                     49972   1
keybdev                  2084   0  (unused)
mousedev                4148   0  (unused)
hid                         21188   0  (unused)
input                        3488   0  [keybdev mousedev hid]
ehci-hcd                 18412   0  (unused)
usb-uhci                  23184   0  (unused)
usbcore                   62988   1  [hid ehci-hcd usb-uhci]


Is it not supposed to be installed since imq0 and imq1 are working?

Also i compiled kernel choosing IMQ device module option.




Artur Szczurzynski wrote:

>
> Hi,
>
> You need to load IMQ Device (imq) module in /etc/modules
> __________________________ *
> initiative** *· · · · ·
> Artur Szczurzynski/
> Network Administrator/*
> T  *+48 22 57 23 389 *
> F  *+48 22 57 23 301*
> C  *+48 505 129 241*
> E  *artur.szczurzynski@pl.initiative.com
>
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
