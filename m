From: "Richard" <richard@o-matrix.org>
Subject: RE: target for modifying conntrack timeout value
Date: Mon, 6 Dec 2004 16:12:25 -1000
Message-ID: <EINSTEIN93MgPPf3L9B00006a59@einstein.systemmetrics.com>
References: <Pine.LNX.4.61.0412061653570.19471@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_03DB_01C4DBAE.637AEF50"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Henrik Nordstrom'" <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0412061653570.19471@filer.marasystems.com>
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

This is a multi-part message in MIME format.

------=_NextPart_000_03DB_01C4DBAE.637AEF50
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

> netfilter moved to subversion some time ago. See announce in the list
> archives.
> 
> It appears the web pages have not been updated yet with the new
> information on how to access the subversion repository.
> 

Ok, I got the latest svn. However I have trouble to get a diff between it
and my working copy. "svn diff" only diffs the existing files and does
generate a patch for new files.

Anyway, I attached this tar.gz file which is extracted into netfilter
directory. Then run "patch -p0 Makefile.diff".

I don't write a 'match' for expire timers because it is already available
through 'match conntrack' with ctexpire option.

It is only available for kernel 2.4, at least for now.

Regards,
Richard

=========================
The related man page part is,

   CTEXPIRE
       This is used to modify the conntrack expire field.  The conntrack
expire field determines how much time left (in seconds) for the conntrack.
The conntrack will  be  deleted  or changed to a new state when the expire
field reachs 0.

       --ctexpire-set value
              Set the conntrack expire value to `value' (in seconds).

       --ctexpire-dec value
              Decrement  the  conntrack  expire  value  `value'  (in
seconds), i.e. make it live shorter.

       --ctexpire-inc value
              Increment the conntrack expire value `value' (in seconds),
i.e. make it live longer.

========================
The help of iptables is,

CTEXPIRE target v1.3.0 options
  --ctexpire-set value          Set conntrack expire to <value>
  --ctexpire-dec value          Decrement conntrack expire by <value>
  --ctexpire-inc value          Increment conntrack expire by <value>



------=_NextPart_000_03DB_01C4DBAE.637AEF50
Content-Type: application/x-gzip;
	name="CTEXPIRE.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="CTEXPIRE.tar.gz"

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

------=_NextPart_000_03DB_01C4DBAE.637AEF50--
