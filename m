From: Balazs Scheidler <bazsi@balabit.hu>
Subject: netfilter on solaris?
Date: Fri, 14 Jun 2002 12:05:40 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020614100540.GA6399@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

It is a strange idea I know, but I'd be interested in what the opinion of
the core netfilter developers is on porting the whole netfilter subsystem to
Solaris?

Apart from the technical issues, would there be any problems? Does the GPL
allow this kind of usage? (it would be implemented as a module)

Technically, the most difficult tasks are to remove the dependency on Linux
like sk_buff (Solaris has a chain of mblk_t's), locking (it's more or less
done using macros), routing differences and I suppose many things I don't
see right now.

ps: don't tell me to use ipfilter (which works on Solaris), it's awful

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
