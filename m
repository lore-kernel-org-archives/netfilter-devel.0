From: "Steve Ashley" <sashley@bsafeonline.com>
Subject: ip_conntrack questions
Date: Thu, 13 Jan 2005 09:44:54 -0600
Message-ID: <A516FD6F11040F4E881C92EDA23F31A8033C2514@mx1.bsafeonline.com>
Reply-To: spanishmack@mchsi.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
content-class: urn:content-classes:message
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

Hi all,

I had previously developed a successful userspace app using libipq =
functionality and I'm now trying to build the same functionality into a =
new netfilter target.=A0 I'm having better success so far than I thought =
I would, using the REDIRECT code as an example.=A0 I have a couple of =
questions relating to kernel space data structures / netfilter =
structures.

In my previous userspace app, I kept track of connections by hashing =
source and destination IPs and ports to index my own data.=A0 It seems =
as if I could use ip_conntrack_get to get at the ip_conntrack stuff and =
just use information from here to help me keep track of my data per =
connections, but I guess I'm still an ultra noob here, because looking =
at all the ip_conntrack stuff is making my head hurt quicker than =
usual.=A0 I've read thru all the docs I can get via netfilter.org, and =
I'm still kind of struggling to understand some of this stuff.=A0 I =
THINK, I kind of get the tuple concept, but I start bogging down quickly =
once I start looking at the hash related stuff.=A0 What information / =
calls would I use to get some unique number I could use in a hashmap or =
a tree structure?

Now, having asked that question, would it be easier to add some custom =
data fields to the ip_conntrack_tuple structure?=A0 I know there are =
people who could do that without even blinking here, but, try to keep =
the answers in the scope of someone who is pretty happy at this point to =
have gotten a working new target that doesn't do much but print out some =
IP info at this point.

Now, having asked the previous questions, maybe it's time for a "forest =
for the trees" question.=A0 What would be the suggestions from this =
group as to the best way to keep track of custom per connection =
information?

Thanks for any information / suggestions in advance.

Steve Ashley
Ashley Professional Services, PA
