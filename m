From: Thomas Knop <tknop@maxrelax.de>
Subject: German translation of the netfilter-extension-HOWTO
Date: Thu, 10 Oct 2002 12:50:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021010105020.GA26751@mail.maxrelax.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear netfilter developers,

i am glad to present you today a german translation of the 
netfilter-extension-HOWTO. Hopefully you will publish it on your famous 
webpage.

Please note, that you must give the '-l de' and '-c latin' options
to sgmltools to do a proper transformation.

There are some minor changes.

Introduction, 1. paragraph (added). German to english translation:
First some words about the german translation of this HOWTO. It's sometime
quite difficult to find the correct translation for technical words. While I
assume that the reader of this document has at least some knowlege about 
networks, protokolls and even netfilter I do not transtate words like
'contrack' or 'match' with to german. If there are some suggestions
or improvements about this translation please send an email to me.

After the thumb roule for p-o-m (added). German to english translation:
Note frome the translator: Yout should install a patch only if you have
understand the explanation and if you are quite sure you need this feature.

length Patch:
Ther is a +/- 1 error. If we want to drop all the pings with a packet size 
*greater* than 85 bytes and ranges are inclusive, the roule must be:

iptables -A INPUT -p icmp --icmp-type echo-request -m length --length 86:65535 -j DROP

Serveral time in the IPv6 Parts:
Basic, works for me 
changed to
Basic, works for Fabrice MARIE (Author of the original Version of this 
Document)

Thank you all, to give me such a powerfull packet filtering for Linx!

Thomas
