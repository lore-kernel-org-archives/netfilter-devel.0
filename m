From: Ozgur AKAN <akan@aiqa.com>
Subject: Re: mask for interface
Date: Tue, 30 Mar 2004 11:32:41 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <406930A9.5070908@aiqa.com>
References: <Pine.LNX.4.44.0403270155130.11373-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0403270155130.11373-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Finally I understand it !

iptables -A test -i eth+ -j ACCEPT
iptables -A test -i eth0 -j ACCEPT
iptables -A test -i eth0+ -j ACCEPT
iptables -A test -i + -j ACCEPT
iptables -A test -i e+ -j ACCEPT

output of a test program is

iface : eth+, Mask is :FF,FF,FF
iface : eth0, Mask is :FF,FF,FF,FF,FF
iface : eth0+, Mask is :FF,FF,FF,FF
iface : +, Mask is :
iface : e+, Mask is :FF


-------test function to print mask value------
static void printMask(unsigned char *mask)
{
    printf("Mask is :");

    while (*mask != '\0') {
        printf("%X%s", *mask, *(mask+1) != '\0' ? "," : "\n");
        ++mask;
    }
}
-----------------------------------------------------



Thanks for your help...

Ozgur AKAN

>Again, it is used for the + wildcard.
>
>In theory it could be used for other things as well, but only the + 
>wildcard is implemented in the iptables application.
>
>Regards
>Henrik
>
>
>
>  
>
