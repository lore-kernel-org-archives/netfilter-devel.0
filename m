From: Martijn Lievaart <m@rtij.nl>
Subject: Re: New extension: CRYPT target
Date: Sun, 21 May 2006 19:51:17 +0200
Message-ID: <4470A895.5090707@rtij.nl>
References: <44708E68.9080508@speedy.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gervasio Bernal <gervasiobernal@speedy.com.ar>
In-Reply-To: <44708E68.9080508@speedy.com.ar>
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

Gervasio Bernal wrote:

>Hi all!!!
>
>After some months of development we have finished this new extension.
>CRYPT is a new target extension for Netfilter/Iptables that enables the
>user to encrypt, decrypt and authenticate any IP protocol traffic using
>the Linux Cryptographic API.
>
>For example, if you want to encrypt FTP (TOP) traffic between host A and
>host B, you can do as follows:
>
>(on host A, 1.2.3.4, FTP client)
># iptables -t mangle -A POSTROUTING -d 1.2.3.5 -p tcp --dport 20:21 -j
>CRYPT --cipher blowfish --key topsecret --mode ecb --direction encrypt
># iptables -t mangle -A PREROUTING -s 1.2.3.5 -p 206 -j CRYPT --cipher
>3des --key topsecretkeyinascii12345 --mode cbc --direction decrypt
>  
>

Minor critisism, this will not catch the data channels of ftp, only the 
control channel. Active ftp uses a *source* port of 20, passive ftp 
(which is more common nowadays) uses whatever port range the server uses 
for data channels (typically something like 30000-31000).

Does -mode cbc use the iv from the last packet? If not, this seems like 
a false sense of security. Protocols that use lots of small packets will 
still more or less have the drawbacks of ecb.

M4
