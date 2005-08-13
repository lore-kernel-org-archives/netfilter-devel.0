From: ori bar <tohava@gmail.com>
Subject: inode recognition in ipt_owner module
Date: Sat, 13 Aug 2005 20:46:19 +0300
Message-ID: <fdbb9d90050813104632639c70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

ipt_owner as it currently is very problematic in matching packets from
a specific app.
(for those of us who want to use it "a-la personal firewall").

the current cmd matching is noit smart because it's only based on the
first 16 letters of a filename, and that can easily be spoofed.

I was wondering, it may be possible to an inode based matching, from
what i've read in the /proc/xxx/exe mechanism source code, all it
takes, is using the pid to get access to a list of file mappings, from
them, take the first executable mapping, from it, get the dentry, from
dentry get inode, and from inode get i_ino which should be the inode
number. This may allow us to better define "app-based rules".

Is there already something like this somewhere in netfilter?
Does anybody want me to try implementing it and send it somewhere
(notice: i never developed kernel modules, i only read them so far, so
i may need some help here)?

Thanks in advance and have a nice day=20

--=20
1110101111111110 - it's a way of life
