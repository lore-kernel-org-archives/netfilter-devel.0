From: Didier Tournier <Didier.TOURNIER@gemplus.com>
Subject: RFC 2694 and iptables.
Date: Mon, 04 Nov 2002 17:20:30 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DC69E4E.6080503@gemplus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
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

Hi,
I would like to build a dns alg with iptables.
The main role of a dns alg is to modify DNS response packet by replacing 
private IP address with public ones.

I ask anybody if it is a good idea to build a new module target and in 
this case if I have to rebuild the kernel or if I could build it in user 
space by using libipq?
Is there any litterature on how to add a new target module for iptables.

Thanks in advance for your help
Didier Tournier

French version :

Bonjour,

Je souhaite écrire un target pour iptables. Celle-ci remplira la 
fonction DNS-ALG pour IPV4.
La fonction principale de ce DNSALG sera de remplacer une adresse privée 
par une publique. (cf RFC 2694).

Pouvez vous me guider un peu sur les points suivant.

Si j'écris un module. dois-je obligatoirement recompiler le noyau ou 
puis je simplement écrire un shared object.
Ou puis je trouver des exemple de makefiles pour ce type de shared objects.
Qu'elle littérature me conseillez vous pour cet exercice?
Est il possible d'écrire une target en utilisant libipq?

Merci d'avance pour votre aide.
Didier Tournier
Gemplus Application research labs.
