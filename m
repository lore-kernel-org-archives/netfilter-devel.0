From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: /etc/sysconfig/iptables format
Date: Sun, 24 Nov 2002 13:28:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200211241328.57401.bdschuym@pandora.be>
References: <Pine.LNX.4.44.0211200005530.5235-100000@azalea.cs.jmu.edu> <20021124104018.GC14672@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>,
	Arch Harris <netfilter02@jah.cs.jmu.edu>
In-Reply-To: <20021124104018.GC14672@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sunday 24 November 2002 11:40, Patrick Schaaf wrote:
Hello,

I'd like your opinion about the way ebtables makes atomically writing a=20
complete table to the kernel, possible.

ebtables uses another approach for getting table data into the kernel=20
atomically.
If you add the parameter --atomic <<FILE>> for each rule added on the com=
mand=20
line, ebtables will use the FILE instead of the kernel data to operate on=
=2E=20
The data in the FILE is a binary format, which can be read with this comm=
and:
ebtables --atomic <<FILE>> -L. The binary format is the exact binary data=
 that=20
have to be given to the kernel to put the table data in the kernel.
Once the rules are set up in FILE, ebtables --atomic-commit <<FILE>> will=
 give=20
the table inside FILE to the kernel. So, only the last command actually=20
changes the kernel data.
Example:
# inits the file filter_table with the default filter table
# (no rules, policies on ACCEPT)
ebtables -t filter --atomic-init  filter_table
# adds a silly rule to the forward chain in filter_table
# this command doesn't talk to the kernel
ebtables -t filter --atomic filter_table -A FORWARD
# overwrites the current kernel filter table data with the filter table d=
ata
# inside the file filter_table
ebtables --atomic-commit filter_table

I was wondering if this is a good scheme, from a user's point of view...
One could say the file being binary is a problem. But the init script for=
 the=20
ebtables tables can be written using the --atomic parameters, and that fo=
rmat=20
is well-defined (just the command line format)... Directly using the bina=
ry=20
file (without constructing it in the scripts) is just an option, it's not=
=20
necessary.

cheers,
Bart
