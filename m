From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: patch-o-matic updated
Date: 07 Apr 2003 17:53:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049730816.26440.150.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

Now patch-o-matic has support for dependencies thanks to Jozsef,
great work!


Modifications I've done:

* Disable dependency-checking for reverse and force modes.
* Add support for empty lines / comments in .depend files.
* Add support for conflicting dependencies.
* Re-add support for sourcetree copying which is needed for correct
  dependency testing (avoids copying when not neccessary).
* Add some dependencies, both normal and conflicting.
* Fix testing and applying of userspace patches.
* Update both kernel- and userspace-patches in userspace/ to make them
  apply again. Split up into more correct pieces and thus avoid
  conflicts with other patches.
* Cleanups which resulted in performance improvements (just continued
  with Jozsef's cleanups).
* Fix problem where circular dependencies were falsely indicated.
* Make userspacepatches work correctly with dependencies.
* Add support for batch testing (--batch --test).
* Fix detection of failed hunks with certain patches.
* More flexible userspace searching.

All changes are in cvs and they _seem_ to work just fine. Can some
people please grab p-o-m from cvs and try applying all the patches you
usually use and report success or failure to me?

I've started working a little on a script to test p-o-m and report any
failures with diffrent patch combinations. I have the easy stuff
finished, will work a bit more on it before I release it.

-- 
/Martin
