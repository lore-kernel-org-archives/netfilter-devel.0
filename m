From: "=?ISO-8859-1?Q?Daniel_Corr=EAa_de_A?=zevedo" <nielca@linkexpress.com.br>
Subject: Compilation problem??
Date: Wed, 30 Jun 2004 12:22:20 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040630141116.M96424@linkexpress.com.br>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

    Hi there. 
    Another problem I'm having with my little HA project is that I added some feature to 
iptables-standalone.c source (basically, add code so that it can send what args it received 
to some other machine that will do the same 'do_command()' call) and I compile only it 
successfully but get a erro message whenever I try to add a rule: 
 
# ./iptables-ha -A INPUT -i ! eth0 -j DROP 
iptables-ha v0.0.99: Couldn't load target `standard':/usr/local/lib/iptables/libipt_standard.so: 
undefined symbol: register_target 
 
   I've searched this at google and I found the same question in a developers mail list, but no 
one answered the question. I was hoping that any of you guys might have a clue of how to 
solve this. 
   If it helps, I'm compiling my iptables-ha-standalone.c with this: 
 
#gcc -o iptables-ha iptables-ha-standalone.c -I ./iptables-ha.o 
/usr/local/src/iptables-1.2.9/include/ /usr/local/src/iptables-1.2.9/iptables.o  
/usr/local/lib/libiptc.a -ldl -g 
 
   I've also tryied with adding the libext.a library, but got the same error. 
 
   Thanks in advance for any help, 
 
       Daniel C. Azevedo 
