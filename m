From: "Alan Cota - Alan" <alan.cota@novaeraconsultores.com.br>
Subject: Authentication - Iptables
Date: Wed, 02 Feb 2005 11:00:42 -0200
Message-ID: <s200b2df.060@brasil.novaeraes.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hello All.
 
Is there any development to implement authentication in Iptables?
Authentication like:
 
$IPTABLES -A FORWARD  -i eth3  -d <IP_OF_MY_SERVER>  -m state --state
NEW  -j MY_RULE 
$IPTABLES -A MY_RULE  -i eth3 -p tcp  -m multiport  --destination-ports
25,443,80  -m state --state NEW  -j AUTHENTICATE
 
About rule abouve, when an internet user try to access my server (on
--destination-ports) the iptables only permit the traffic if the
authentication is correct.
 
The rule abouve is only an example.
 
Is there any development to implement this feature, or anyone knows how
to implement this?
 
Tks,
 
Regards,
Alan Cota. 
