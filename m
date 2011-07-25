From: "Julio A. Romero" <julioarr@fisica.uh.cu>
Subject: about --source and --destination
Date: Mon, 25 Jul 2011 14:59:24 -0400
Message-ID: <95BB8A9157A549DB90DCE7AB0D03E4AD@poweredge1800>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: <netfilter@vger.kernel.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

At times I have needed to specify pairs of rules for the sources and the 
destinations, even when sources and destinations are the same networks, i.e.



iptables -N netfilterup

iptables -A netfilterup -d $NETWORKS -j RETURN

iptables -A netfilterup -j DROP



iptables -N netfilterin

iptables -A netfilterin -s $NETWORKS -j RETURN

iptables -A netfilterin -j DROP



iptables -A FORWARD -i $INT_IFACEs -j netfilterup

iptables -A FORWARD -i $EXT_IFACEs -j netfilterin



Exists some way of writing something like that?



iptables -N netfilter

iptables -A netfilter -s/-d $NETWORKS -j RETURN

iptables -A netfilter -j DROP

iptables -A FORWARD -j netfilter



thanks,

julio

