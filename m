From: hamid jafarian <hamid.jafarian@gmail.com>
Subject: a new version of iptabes
Date: Thu, 7 Apr 2005 01:04:53 -0700
Message-ID: <464293e60504070104d1a3029@mail.gmail.com>
References: <464293e605040500395fa1fe55@mail.gmail.com>
	<464293e60504050045720b8e52@mail.gmail.com>
Reply-To: hamid jafarian <hamid.jafarian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <464293e60504050045720b8e52@mail.gmail.com>
Content-Disposition: inline
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

hello ...

I was developed a new version of iptables .. this version is based on the=
=20
requirements of firewalls with 25,000 rules or may be more..

Your version of iptables with continues memory for rule storage and linear=
=20
search in the classification activities, can only manage firewalls with les=
s=20
than 1000 rules ( base on my tests ) but in my version, there is a very goo=
d=20
chance for increasing the search activities: in this version you can use=20
different classification algorithms to classify the packets ( up now only=
=20
"linear" & "tuple" ). this algorithms can be developed like of targets and=
=20
matches independent of the core .. and with a command option ( -C ) you can=
=20
change the classification algorithm of a chain .. every chain (in this=20
development) could have his own algorithm .. by this we can hope that the=
=20
iptables will never be old.
You know that the classification algorithms (like of HiCuts & BV & Hypercut=
s=20
) are developed to manage the classifying process of the packets.
 Another feature of this develop is using of link list instead of continues=
=20
memory for rule storage. By this strategy, adding or deleting a rule just=
=20
need to exchange the information of that rule between the user and kernel=
=20
space, but in your version, you should exchange all of the database between=
=20
the user and kernel space and also, do some expensive memory management=20
activities ( free old database and allocate new memory for the new database=
,=20
copy all of the database from the user space to the kernel space and also=
=20
transform all of the rules, from user form to kernel form ) in the kernel=
=20
space. your iptables is not appropriate for interactive firewalls but in=20
this version, interactivity is a base feature.
 By this .. i was transformed all of the rule management activities from=20
user space to the kernel space ..
 This version is very flexible and powerful and can be used instead of the=
=20
current version of iptables.
 I also was done some tests on the new version. if you like i can give you=
=20
the results of this tests and also if you wish, give you this version for=
=20
testing, using and (may) replacing the current version with this powerful=
=20
version.

this version is developed only for IPV4 .. and the code that is used and=20
changed for the user space is 1.2.9 ..
in the coding of this version, i was used form many new and appropriate=20
structures for easy to understand and change ... like of your style for=20
coding in the user space ( using macroes for IPV4 and IPV6 coding) we can=
=20
use this style for coding the IPV6.

IMPORTANT: the "iptables" command is not changed and you can use from the=
=20
iptables and all of the current matches and targets without any changes or=
=20
new information, and also the commands of iptabes-save and iptables-restore=
=20
is changed to work with this new version.

this version is a GOOD CHANCE ............

be happy ..
 ... hamid jafarian ...
 --=20
H.T.
