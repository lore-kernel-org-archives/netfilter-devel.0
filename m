From: "=?Windows-1252?Q?Antonio_E._Mart=EDnez?=" <Antonio.Martinez@iic.uam.es>
Subject: Connection Tracking and FIN+ACK packets
Date: Wed, 26 Jun 2002 12:09:48 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <00d301c21cf9$9a96be40$2e14f496@iic.uam.es>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I am not sure if this matter has been discussed previously... If that's
true, please, point me to the place where the answer is...

I am using netfilter on a screening router, and I detected that FIN+ACK
packets coming from web sites are blocked by the firewall.
For the moment, I am using a configuration to allow "flat" access from my
internal network, allowing responses from external sites, with these
iptables rules:

iptables -A FORWARD -v -i $IFINT -s $IPINT -m state --state
NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -v -i $IFEXT -s $IPANY -m state --state ESTABLISHED -j
ACCEPT

(I think variables are "self explained"...)

According to "IPTables connection tracking" document, the closure proceeds
in this way:

       Client                    Server
                        .........
   FIN+ACK   --->
                        <---        ACK
                        <---     FIN+ACK
         ACK      --->

It seems status "ESTABLISHED" is finished with the first "FIN+ACK" package
sent by the client, and then last "FIN+ACK" package, coming from the Server,
is rejected by the firewall rules. Am I correct? If the answer is "yes", are
there any way (or fix) to solve that?
And if I am wrong, please, tell me... Thank you very much.

Best regards. Antonio.
