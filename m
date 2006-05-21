From: Gervasio Bernal <gervasiobernal@speedy.com.ar>
Subject: New extension: CRYPT target
Date: Sun, 21 May 2006 12:59:36 -0300
Message-ID: <44708E68.9080508@speedy.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
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

Hi all!!!

After some months of development we have finished this new extension.
CRYPT is a new target extension for Netfilter/Iptables that enables the
user to encrypt, decrypt and authenticate any IP protocol traffic using
the Linux Cryptographic API.

For example, if you want to encrypt FTP (TOP) traffic between host A and
host B, you can do as follows:

(on host A, 1.2.3.4, FTP client)
# iptables -t mangle -A POSTROUTING -d 1.2.3.5 -p tcp --dport 20:21 -j
CRYPT --cipher blowfish --key topsecret --mode ecb --direction encrypt
# iptables -t mangle -A PREROUTING -s 1.2.3.5 -p 206 -j CRYPT --cipher
3des --key topsecretkeyinascii12345 --mode cbc --direction decrypt

(on host B, 1.2.3.5, FTP server)
# iptables -t mangle -A POSTROUTING -d 1.2.3.4 -p tcp --sport 20:21 -j
CRYPT --cipher 3des --key topsecretkeyinascii12345 --mode cbc
--direction encrypt
# iptables -t mangle -A PREROUTING -s 1.2.3.4 -p 206 -j CRYPT --cipher
blowfish --key topsecret --mode ecb --direction decrypt

_Note_ the symmetry in the rules. Also note the use of protocol 206
(CRYPT_PROTOCOL) in decryption.

We hope you can test it and we are open for comments and suggestions.

--
Gervasio Bernal <gervasiobernal(at)gmail(dot)com>
Pedro Deis <pedrakos(at)gmail(dot)com>
