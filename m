From: allen <aef@prismnet.com>
Subject: Re: Hi...
Date: Sat, 18 Jan 2003 20:53:09 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301182053.10001.aef@prismnet.com>
References: <20030118222445.99766.qmail@web20908.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel <da_tes@yahoo.com.ar>,
	NetFilter <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20030118222445.99766.qmail@web20908.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


On Saturday 18 January 2003 04:24 pm, Daniel wrote:
> Hi, thanks to all of you for share your opinion with me and be sure
> that I will be glad to add all your needs to gtk-iptables. Just give me
> time.
>
> I do not write gtk-iptables because I want to learn how to use
> iptables, because I know how to use it, is just that I learn how to
> programm with Gtk and I thought that it will nice to have a GUI for
> iptables, that for people new to iptables will be much more easy and
> for advanced users much more quickly to make rules. Thanks again and
> keep sending comments and opinions.


Daniel,

Once when I had time I was working on "St. Elmo's Firewall",
a gui that would work with IPTables rules.

It is a VERY difficult thing to decide how to present a GUI.

Just IPTables rules ?  Or something abstracted and user friendly ?

With nmap type features ?  With ability to ping and discover
a local network, services, etc., ?

With ability to manage FreeS/Wan IPSec ?

Also, I was looking into settings that are affected in /proc related to 
networking.  Click and enable, what value needs to go where...

And what modules need to be loaded ?

Also, everything in it has lots of Help explaining this that and the other 
thing.

As it is a prototype, the things that work best in the code I can 
dig up are the HELP, and the driving of Nmap.

What I have is a concept than happens to run and you are welcome
to check it out for ideas and even take it over.

It is unlikely that I will find the time to do anything other that clean
it up a bit and stick it on Sourceforge.

FYI
-AEF
